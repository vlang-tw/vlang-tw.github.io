module lib

pub struct OGData {
pub mut:
	title       string
	@type       string = 'website'
	image       string
	url         string
	description string
	locale      string = 'en_US'
	site_name   string
}

pub struct Meta {
pub mut:
	charset     string = 'UTF-8'
	author      string
	description string
	og          OGData = OGData{}
}
