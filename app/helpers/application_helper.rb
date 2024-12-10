module ApplicationHelper
  include Helpers::DomHelper

  def render_turbo_stream_flash_messages
    turbo_stream.append "flash", partial: "layouts/flash"
  end
end
