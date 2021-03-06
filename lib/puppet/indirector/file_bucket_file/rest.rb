require 'puppet/indirector/rest'
require 'puppet/file_bucket/file'

module Puppet::FileBucketFile
  class Rest < Puppet::Indirector::REST
    desc "This is a REST based mechanism to send/retrieve file to/from the filebucket"
    def head(request)
      session = Puppet.lookup(:http_session)
      api = session.route_to(:puppet)
      api.head_filebucket_file(
        request.key,
        environment: request.environment.to_s,
      )
    rescue Puppet::HTTP::ResponseError => e
      return nil if e.response.code == 404
      raise convert_to_http_error(e.response.nethttp)
    end

    def find(request)
      session = Puppet.lookup(:http_session)
      api = session.route_to(:puppet)
      api.get_filebucket_file(
        request.key,
        environment: request.environment.to_s,
      )
    rescue Puppet::HTTP::ResponseError => e
      raise convert_to_http_error(e.response.nethttp)
    end

    def save(request)
      session = Puppet.lookup(:http_session)
      api = session.route_to(:puppet)
      api.put_filebucket_file(
        request.key,
        body: request.instance.render,
        environment: request.environment.to_s,
      )
    rescue Puppet::HTTP::ResponseError => e
      raise convert_to_http_error(e.response.nethttp)
    end
  end
end
