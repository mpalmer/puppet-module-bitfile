Puppet::Type.newtype :underscore_bit_file_bit do
	desc <<-EOF.gsub(/^\t\t/, '')
		Represents a single chunk in a bitfile.  This type doesn't really do
		anything of its own; it just sits around waiting to be collected by
		`_bit_file`.

		Which bits belong to which file are sorted out with `path`.  The
		`_bit_file` type will collect all the `_bit_file_bit` resources which
		have the same `path` as the `_bit_file` resource's title (namevar).

		The order in which the bits are put together is dependent on both the
		`ordinal` parameter, as well as a simple tree hierarchy.  Any bit which
		has a `parent` attribute will be render after the parent's contents, but before
		the content of the next bit after the parent.
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

	newparam :parent do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			Identifies the "parent" bit.
		EOF

		defaultto :undef

		validate do |parent|
			unless parent == :undef or parent.is_a? String
				raise ArgumentError,
				      "`:parent` must be a string"
			end
		end
	end

	newparam :content do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			What is in this bit.
		EOF

		validate do |content|
			unless content.is_a? String or content == :undef
				raise ArgumentError,
				      "`:content` must be a string"
			end
		end
	end

	newparam :source do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			The file from which to read the contents of this bit.
		EOF

		validate do |source|
			unless source.is_a? String or source == :undef
				raise ArgumentError,
				      "`:source` must be a string"
			end
		end
	end

	newparam :closing_content do
		desc <<-EOF.gsub(/^\t\t\t/, '')
			An optional string which will be printed after any child bits.
		EOF

		defaultto ''

		validate do |content|
			unless content.is_a? String
				raise ArgumentError,
				      "`:closing_content` must be a string"
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
