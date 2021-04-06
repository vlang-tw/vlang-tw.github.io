module main

import os
import lib

const (
	language   = 'zh-Hant-TW'
	locale     = 'zh_TW'
	domain     = 'vlang.tw'
	author     = 'vlang-tw'
	base_title = 'V 程式語言台灣使用者社群'
	base_desc  = '讓V 程式語言的台灣使用者們一起分享討論的社群，經營V 程式語言在台灣的生態圈。'
)

fn https(subdomain string, path string) string {
	if subdomain == '' {
		return '${@FN}://$domain$path'
	}
	return '${@FN}://${subdomain}.$domain$path'
}

pub fn unplash_attribution_html(author_id string, author_name string) string {
	params := 'utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText'
	return 'Photo by <a href="https://unsplash.com/$author_id?$params">$author_name</a>'
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
	return $tmpl('templates/index.html')
}

fn main() {
	s := index(language, base_title, https('', '/'))
	os.write_file('docs/index.html', s) or { panic(err) }
}
