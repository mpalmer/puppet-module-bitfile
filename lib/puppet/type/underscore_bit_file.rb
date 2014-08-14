Puppet::Type.newtype :underscore_bit_file do
	desc <<-EOF.gsub(/^\t\t/, '')
		A file that is made up of bits.
	EOF

	newparam :path do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			The file that is made up of bits.  Must be fully-qualified, because
			Puppet doesn't really have a concept of a "current working
			directory".
		EOF
		isnamevar

		validate do |path|
			unless path.is_a? String
				raise ArgumentError,
				      "`:path` must be a string"
			end
			unless path =~ %r{^/}
				raise ArgumentError,
				      "`:path` (#{path}) is not fully qualified"
			end
		end
	end

	newparam :mode do
		desc <<-EOF
			The mode of the file once its created.
		EOF
	end

	newparam :owner do
		desc <<-EOF
			The owner of the created file.
		EOF
	end

	newparam :group do
		desc <<-EOF
			The group for created file.
		EOF
	end

	def bits
		catalog.resources.select do |r|
			r.type == :underscore_bit_file_bit and r[:path] == self[:path]
		end
	end
	
	def content
		bits.sort_by { |r| [r[:ordinal], r[:content]] }.map { |r| r[:content] }.join("\n") + "\n"
	end

	def generate
		meta_attrs = Puppet::Type.metaparams.inject({}) { |h, m| h[m] = self[m]; h }

		file_attrs = meta_attrs.merge(
		               :path => self[:path],
		               :content => content,
		               :mode    => self[:mode],
		               :owner   => self[:owner],
		               :group   => self[:group]
		).delete_if { |k,v| v.nil? }

		[Puppet::Type.type(:file).new(file_attrs)]
	end
end
