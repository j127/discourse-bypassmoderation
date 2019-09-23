# name: discourse-bypassmoderation
# about: Bypass post moderation for certain users.
# version: 0.0.1
# authors: j127 (based on a plugin by Leo Davidson)
# url: https://www.github.com/j127/discourse-bypassmoderation

enabled_site_setting :bypass_moderation_enabled

after_initialize do
  module ::DiscourseBypassModeration
    def post_needs_approval?(manager)
      super_result = super

      # Return the normal moderation rule if plugin is off.
      return super_result if !SiteSetting.bypass_moderation_enabled

      # Otherwise, if the username is in the plugin's settings, return `:skip`.
      if SiteSetting.bypass_moderation_users.is_a? String
        username = manager.user.username.downcase
        userarray = SiteSetting.bypass_moderation_users
                               .downcase
                               .split('|')
                               .map(&:strip)
        return :skip if userarray.include? username
      end

      super_result
    end
  end

  NewPostManager.singleton_class.prepend ::DiscourseBypassModeration
end
