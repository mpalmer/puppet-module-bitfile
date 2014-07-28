Puppet::Type.newtype :underscore_bit_file_bit do
	desc <<-EOF.gsub(/^\t\t/, '')
		Represents a single chunk in a bitfile.  This type doesn't really do
		anything of its own; it just sits around waiting to be collected by
		`_bit_file`.  Which bits belong to which file are sorted out with
		`path`; the order in which the bits are glued together is taken from
		the `ordinal` attribute; this must be a non-negative integer.  The
		ordering of bits with the same `ordinal` is not specified.
	EOF

	newparam :name do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			Unique name for the fragment.  Irrelevant to this type's operation.
		EOF
		isnamevar
	end

	newparam :path do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			Identifies the file this bit is associated with.
		EOF

		validate do |path|
			unless path.is_a? String
				raise ArgumentError,
				      "`:path` must be a string"
			end

			unless path =~ %r{^/}
				raise ArgumentError,
				      "`:path` (#{path}) must be fully-qualified"
			end
		end
	end

	newparam :content do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			What is in this bit.
		EOF

		validate do |content|
			unless content.is_a? String
				raise ArgumentError,
				      "`:content` must be a string"
			end
		end
	end

	newparam :ordinal do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			The relative position of this bit in the file.

			If this parameter is omitted, it defaults to 50.
		EOF
		defaultto 50

		validate do |ordinal|
			unless ordinal.is_a? String or ordinal.is_a? Integer
				raise ArgumentError,
				      "`:ordinal` must be a string or integer"
			end
		end

		munge do |ordinal|
			ordinal.to_i
		end
	end
end
