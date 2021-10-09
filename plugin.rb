# frozen_string_literal: true

# name: discourse-allow=fields
# about: Allows field for topic tracking state
# version: 0.1
# author: Ahmed Gagan
# url: https://github.com/Ahmedgagan/discourse-allow-fields

enabled_site_setting :discourse_allow_fields_enabled

after_initialize do
  SiteSetting.discourse_allow_fields_name.split('|').each do |field|
    add_to_serializer(:topic_tracking_state, field) do
      topic = Topic.find(object.topic_id)
      topic[field]
    end
  end

  add_to_serializer(:topic_tracking_state, :solved) do
    topic = Topic.find(object.topic_id)
    !!topic.custom_fields["accepted_answer_post_id"]
  end

  add_to_serializer(:current_user, :bookmark_count) do
    scope.user.bookmarks.filter { |bookmark| bookmark.post }.count
  end

end