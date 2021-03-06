module ApplicationHelper
  def strip_chars(string='')
    return '' if string.blank?
    string.gsub(/\s+/,'-').gsub(/[^a-z0-9\-]+/i, '').gsub(/[\-]+/,'-')
  end

  def show_tags(object=nil)
    return '' if object.nil?
    output = ""
    if object.tags.present?
      output << '<p class="tagged">Tagged: '
      object.tags.each do |tag|
        output << link_to(tag.name, tagged_path(:name => strip_chars(tag.name), :page => nil))
      end
      output << '</p>'
    end
  end

  def tag_class(ratio=0)
    return '' if ratio == 0
    if (1..5).include?(ratio)
      return 'level_one'
    elsif (6..10).include?(ratio)
      return 'level_two'
    elsif (11..25).include?(ratio)
      return 'level_three'
    elsif (26..30).include?(ratio)
      return 'level_four'
    elsif (31..50).include?(ratio)
      return 'level_five'
    else
      return 'level_six'
    end
  end
end
