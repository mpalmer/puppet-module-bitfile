define bitfile::bit(
		$path,
		$parent          = undef,
		$content         = undef,
		$source          = undef,
		$closing_content = '',
		$ordinal         = 50
) {
	if ($content == undef and $source == undef) or ($content != undef and $source != undef) {
		fail("Must specify exactly one of 'content' and 'source'")
	}

	underscore_bit_file_bit { $name:
		path            => $path,
		parent          => $parent,
		ordinal         => $ordinal,
		content         => $content,
		source          => $source,
		closing_content => $closing_content,
		before          => $before,
		require         => $require,
		notify          => $notify,
		subscribe       => $subscribe,
	}
}
