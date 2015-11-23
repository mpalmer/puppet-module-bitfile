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

	def file_bits
		@file_bits ||= catalog.resources.select do |r|
			r.type == :underscore_bit_file_bit and r[:path] == self[:path]
		end
	end

	def bit_node_content(parent)
		file_bits.select { |r| r[:parent] == parent }.map do |r|
			[r[:ordinal], nl(r[:content]) + nl(bit_node_content(r[:name])) + nl(r[:closing_content])]
		end.sort.map { |r| r.last }.join("")
	end

	def content
		bit_node_content(:undef)
	end

	def generate
		f = Puppet::Type.type(:file).new(
		                               :path    => self[:path],
		                               :content => content,
		                               :mode    => self[:mode],
		                               :owner   => self[:owner],
		                               :group   => self[:group],
		                               :catalog => self.catalog,
		                             )

		debug "Generated bitfile: #{f.ref}"

		self.parameters.each do |name, param|
			f[name] = param.value if param.metaparam?
		end

		f.builddepends.each { |e| f.catalog.relationship_graph.add_edge(e) }

		[f]
	end

	private

	def nl(s)
		s.empty? ? '' : s + "\n"
	end
end
