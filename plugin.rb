# frozen_string_literal: true

# name: discourse-ahs-sanghaspace
# version: 0.1
# author: Ahmed Gagan
# url: https://github.com/Ahmedgagan/discourse-ahs-sanghaspace

enabled_site_setting :discourse_ahs_sanghaspace_enabled

after_initialize do
  SiteSetting.discourse_ahs_sanghaspace_topic_fields_name.split('|').each do |field|
    value = field.to_sym
    add_to_serializer(:topic_tracking_state, value) do
      topic = Topic.find(object.topic_id)
      return topic[value] if topic.has_attribute?(value)

      topic.custom_fields[value]
    end
  end

  add_to_serializer(:current_user, :bookmark_count) do
    scope.user.bookmarks.filter { |bookmark| bookmark.post }.count +
    Topic.joins("INNER JOIN assignments a ON topics.id = a.topic_id").where("a.assigned_to_id = ?", scope.user.id).count
  end
end
