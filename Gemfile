# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.1.2"
dm_gems_version   = "1.0.0"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
# If you did disable json for Merb, comment out this line.
# If you want use json gem just change it.
# Don't use json gem version lower than 1.1.7! Older versions has security bug!
gem "json_pure", ">= 1.1.7", :require => "json"
gem "facets"
gem "merb-core", merb_gems_version
gem "merb-assets", merb_gems_version

gem("merb-cache", merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end

gem "merb-flash"
gem "merb-helpers", merb_gems_version
gem "merb-mailer", merb_gems_version
gem "merb-slices", merb_gems_version
gem "merb-auth-core"
gem "merb-auth-more"
gem "merb-auth-slice-password"
gem "merb-param-protection", merb_gems_version
gem "merb-exceptions", merb_gems_version

gem "dm-mysql-adapter"
gem "dm-core", dm_gems_version
gem "dm-aggregates", dm_gems_version
gem "dm-migrations", dm_gems_version
gem "dm-timestamps", dm_gems_version
gem "dm-types", dm_gems_version
gem "dm-validations", dm_gems_version
gem "dm-serializer", dm_gems_version

gem "merb_datamapper", "1.2.0"

gem "thin"
