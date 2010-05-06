# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.1.0"
dm_gems_version   = "0.10.2"
do_gems_version   = "0.10.1"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
# If you did disable json for Merb, comment out this line.
# If you want use json gem just change it.
# Don't use json gem version lower than 1.1.7! Older versions has security bug!
gem "json_pure", ">= 1.1.7", :require => "json"
gem "merb-core", merb_gems_version
gem "merb-action-args", merb_gems_version
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
gem "merb-auth-core", merb_gems_version
gem "merb-auth-more", merb_gems_version
gem "merb-auth-slice-password", merb_gems_version
gem "merb-param-protection", merb_gems_version
gem "merb-exceptions", merb_gems_version

gem "data_objects", do_gems_version
gem "do_mysql", do_gems_version
gem "dm-core", dm_gems_version
gem "dm-aggregates", dm_gems_version
gem "dm-migrations", dm_gems_version
gem "dm-timestamps", dm_gems_version
gem "dm-types", dm_gems_version
gem "dm-validations", dm_gems_version
gem "dm-serializer", dm_gems_version

gem "merb_datamapper", merb_gems_version

gem "thin"
gem "facets"
