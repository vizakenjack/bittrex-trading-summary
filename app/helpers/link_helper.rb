module LinkHelper

  def link_show(path)
    link_to path, class: "btn btn-md btn-primary" do
      glyph('th-list') + ' Show'
    end
  end

  def link_destroy(path, *args)
    options = {method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-md btn-danger"}
    options.merge!(args.first)  if args.present?
    link_to path, options do
      glyph('remove-sign') + ' Destroy'
    end
  end

  def round_selector(rounds, current_round)
    rounds.collect do |r|
      link_to(r, trade_path(id: @trade.id, round: r), class: "btn btn-primary#{' active'  if r == current_round.to_i}", remote: true)
    end.join.html_safe
  end


end