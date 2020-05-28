# Ruby filter plugin: https://www.elastic.co/guide/en/logstash/current/plugins-filters-ruby.html
# Event API: https://www.elastic.co/guide/en/logstash/current/event-api.html

def register(params)
    @mapping = params
end

def filter(event)
    for i in @mapping.keys() do
        if @mapping[i].include? event.get('src_addr') then
        # if @mapping[i].include? event['src_addr'] then
            # event['device_name'] = i
            event.set('device_name', i)
            break
        end
    end
    return [event]
end

# for test
# p = {
#     "BIGIP1" => ["X", "Y", "Z"],
#     "BIGIP2" => ["A", "B", "C"]
# }

# e = {
#     "src_addr" => "Y",
# "rst_from_type" => "RST from BIG-IP internal Linux host",
# "process_name" => "tmm3",
#    "timestamp" => "2020-05-28T04:52:26.000Z",
#     "hostname" => "F5-LTM-7000-OAEBANK-01",
#     "dst_port" => "57592",
#         "type" => "kafka",
#     "dst_addr" => "10.235.99.238",
#     "src_port" => "1171",
#   "@timestamp" => "2020-05-28T07:01:02.848Z",
#   "process_id" => "24144",
#    "log_level" => "err"
# }

# register(p)
# filter(e)

# print e