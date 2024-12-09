module DomHelper
  include ActionView::RecordIdentifier unless defined?(dom_id)

  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
  end
end
