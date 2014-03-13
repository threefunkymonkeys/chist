module Chist::Helpers
  def not_found!
    res.redirect '/404'
  end
end
