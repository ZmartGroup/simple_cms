class CmsAuthorizer < Authority::Authorizer

  def self.default(adjective, agent)
    # 'Whitelist' strategy for security: anything not explicitly allowed is
    # considered forbidden.
    false
  end
end
