# frozen_string_literal: true

module SitesHelper
  def self.update_sites
    require 'net/http'
    url = URI.parse('http://api.stackexchange.com/2.2/sites?pagesize=1000&filter=!*L1-85AFULD6pPxF')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    sites = JSON.parse(res.body)['items']
    return unless sites.count > 100 # all is not well; bail
    sites.each do |site|
      s = Site.find_or_create_by(site_domain: URI.parse(site['site_url']).host)
      s.site_url = site['site_url']
      s.site_logo = site['favicon_url'].gsub(/http:/, '')
      s.site_name = site['name']
      s.is_child_meta = site['site_type'] == 'meta_site'
      s.save!
    end
  end
end
