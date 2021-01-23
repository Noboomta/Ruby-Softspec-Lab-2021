# 6210545734 Puvana Swatvanith SKE17
require 'net/http'
require 'uri'
require 'nokogiri'

all_prefix = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
base_url = 'https://www.set.or.th/set/commonslookup.do?language=th&country=TH&prefix='
base_url_company = 'https://www.set.or.th'

(0..all_prefix.length - 1).each do |i|
  current_url =  base_url + all_prefix[i]
  current_source = Net::HTTP.get(URI.parse(current_url))
  current_doc = Nokogiri::HTML(current_source)
  a_in_table = current_doc.css('table.table-profile.table-hover.table-set-border-yellow').css('a')
  all_link = a_in_table.map { |element| element['href'] }.compact

  all_link.each do |link|
    link['companyprofile'] = 'companyhighlight'
    link['PageId=4'] = 'PageId=5'
    # puts base_url_company + link
    company_source = Net::HTTP.get(URI.parse(base_url_company + link))
    company_doc = Nokogiri::HTML(company_source)
    all_td_in_table = company_doc.css('div.table-responsive').css('table.table-hover.table-info').css('tbody')
    money_line = all_td_in_table.css('td')[6].inner_html
    money_line = all_td_in_table.css('td')[4].inner_html if money_line == 'หนี้สินรวม'
    company_name = company_doc.css('div.col-xs-12.col-md-12.col-lg-8').css('h3').to_s
    print company_name[4, company_name.length - 9], ' : ', money_line, "\n"
  end
end
