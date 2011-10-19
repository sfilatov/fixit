class DashboardController < ApplicationController
  JENKINS_RSS = File.join("#{Rails.root}", 'rss.xml')

  def index
    if File.exists?(JENKINS_RSS)
      hash = Crack::XML.parse File.open(JENKINS_RSS).read
      rss = Hashie::Rash.new hash
      @projects = rss.projects? && rss.projects.project ? rss.projects.project : []
    else
      @projects = []
    end
  end
end
