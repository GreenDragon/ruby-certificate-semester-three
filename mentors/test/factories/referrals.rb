Factory.define :referral do |r|
  r.reference_for 'First Last'
  r.name 'RFirst RLast'
  r.address '2706 S. Jackson St.'
  r.city 'Seattle'
  r.state 'WA'
  r.zipcode '98144'
  r.day_phone '(206) 709-2228'
  # r.evening_phone 'MyString'
  # r.cell_phone 'MyString'
  r.email 'rfirst@rlast.com'
  # r.known_months '1'
  # r.known_years '1'
  r.what_capacity 'MyText'
  r.working_with_children 'MyText'
  r.any_concerns 'MyText'
  # r.role_model '1'
  # r.reliability '1'
  # r.creativity '1'
  # r.enthusiasm '1'
  # r.cultural_awareness '1'
  # r.patience '1'
  # r.additional_comments 'MyText'
end

Factory.define :good_referral, :parent => :referral do |g|
  g.email 'gfirst@glast.org'
end
