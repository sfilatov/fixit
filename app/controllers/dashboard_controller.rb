require 'net/http'
require 'net/https'

class DashboardController < ApplicationController

  def index
    rss = Hashie::Rash.new Crack::XML.parse(fetch_rss.body)
    @projects = (rss.projects? && rss.projects.project ? rss.projects.project : []).sort{|x, y| x.name <=> y.name}

    if params[:projects]
      render :partial => 'projects', :layout => false
    end
  end

  private

  def fetch_rss
    url = URI.parse("#{configatron.jenkins.protocol}://#{configatron.jenkins.host}/#{configatron.jenkins.rss_url}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    req = Net::HTTP::Get.new(url.path)
    req.basic_auth(configatron.jenkins.username, configatron.jenkins.password) if http.use_ssl?

    response = http.request(req)

    case response
      when Net::HTTPSuccess then response
      else response.error!
    end
  end
end
