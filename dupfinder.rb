require 'find'
require 'thread'
require 'digest/md5'
#finds and prints duplicate files
@hash = Hash.new
@array = Array.new
@threads = Array.new
@mutex = Mutex.new
@num_threads = 8 #enter number of threads you want to use here
@directory = "C:/" #enter the directory you want to search here
Find.find(@directory) { |path| File.directory?(path) ? next : @array << path }
@array.each_slice(@array.size/@num_threads) do |slice|
	thread = Thread.new (slice) do |threadslice|
		slice.each do |path|
			digest = Digest::MD5.file(path).hexdigest
			@mutex.synchronize { @hash.include?(digest) ? p(path) : @hash[digest]=true }
		end
	end
	@threads << thread
end
@threads.each { |thread| thread.join }