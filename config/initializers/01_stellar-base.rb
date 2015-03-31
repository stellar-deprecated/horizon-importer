
# NOTE: It may look a little weird that we're including stellar-core in
# our Gemfile with "require:false" only to immediately require it here.
# This is due to an ordering issue while running the test suite in Travis CI.
# libsodium isn't available on travis, which is required for rbnacl, one of
# stellar-core's dependencies. rbnacl provides a rake task to make it easy to 
# build sodium on travis, but unfortunatley the initialization process for 
# rails will require rbnacl before we run the rake task to build libsodium.
# 
# By moving the require of stellar-core into this system, I'm hoping we will
# be able to initialize rails to the point where rake tasks can run.
# 
require 'stellar-base'
