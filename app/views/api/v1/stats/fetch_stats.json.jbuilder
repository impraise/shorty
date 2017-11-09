json.ignore_nil!
if @short_link
  json.start_date @object['start_date']
  json.redirect_count @object['redirect_count']
  json.last_seen_date @object['last_seen_date']
else
  json.errors @object
end
