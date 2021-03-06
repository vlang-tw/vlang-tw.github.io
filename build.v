module main

import os
import time
import lib
import markdown

const (
	language   = 'zh-Hant-TW'
	locale     = 'zh_TW'
	domain     = 'vlang.tw'
	author     = 'vlang-tw'
	base_title = 'V 程式語言台灣使用者社群'
	base_desc  = '提供使用 V 程式語言的台灣開發者可以一起分享討論的社群，共同經營V 程式語言在台灣的應用生態圈。'
)

fn https(subdomain string, path string) string {
	if subdomain == '' {
		return '${@FN}://$domain$path'
	}
	return '${@FN}://${subdomain}.$domain$path'
}

fn unplash_attribution_html(author_id string, author_name string) string {
	params := 'utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText'
	return 'Photo by <a href="https://unsplash.com/$author_id?$params">$author_name</a>'
}

fn gen_url_set(work_path string, enpoint string, additionals []string) []lib.URLentry {
	len := work_path.len
	paths := os.walk_ext(work_path, 'html')
	time_now := time.now()
	mut entry := []lib.URLentry{}
	for path in paths {
		mut sub := path[len..]
		if sub == 'index.html' {
			entry << lib.URLentry{
				loc: enpoint
				lastmod: time_now.ymmdd()
			}
		} else if sub != '404.html' {
			entry << lib.URLentry{
				loc: '$enpoint$sub'
				lastmod: time_now.ymmdd()
			}
		}
	}
	for path in additionals {
		entry << lib.URLentry{
			loc: '$enpoint?/$path' // SPA redirect link
			lastmod: time_now.ymmdd()
		}
	}
	return entry
}

fn md_file_to_html(file_path string) string {
	md := os.read_file(file_path) or { panic(err) }
	return markdown.to_html(md)
}

//==========

fn index(lang string, title string, canonical string) string {
	mut meta := lib.Meta{
		author: author
		description: base_desc
	}
	meta.og.title = base_title
	meta.og.image = https('', '/assets/img/og/index.png')
	meta.og.url = canonical
	meta.og.description = base_desc
	meta.og.locale = locale
	meta.og.site_name = domain
	// email
	email := 'contact@$domain'
	// Unsplash Photo
	html_unplash_attribution := unplash_attribution_html('@joannakosinska', 'Joanna Kosinska')
	// page content from markdown
	md_about_us := md_file_to_html('data/about-us.md')
	return $tmpl('templates/index.html')
}

fn sitemap(url_set []lib.URLentry) string {
	return $tmpl('templates/sitemap.xml')
}

fn notfound(lang string, title string) string {
	return $tmpl('templates/404.html')
}

fn main() {
	endpoint := https('', '/')
	mut s := ''
	s = index(language, base_title, endpoint)
	os.write_file('docs/index.html', s) or { panic(err) }
	additionals := ['about-us']
	s = sitemap(gen_url_set('docs/', endpoint, additionals))
	os.write_file('docs/sitemap.xml', s) or { panic(err) }
	s = notfound(language, base_title)
	os.write_file('docs/404.html', s) or { panic(err) }
	// robots.txt
	os.write_file('docs/robots.txt', 'Sitemap: ${https('', '/sitemap.xml')}') or { panic(err) }
}
