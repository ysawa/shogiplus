guard 'rspec', :cli => "--color --fail-fast" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/support/.+.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
