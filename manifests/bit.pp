define bitfile::bit(
		$path,
		$parent          = undef,
		$content,
		$closing_content = '',
		$ordinal         = 50
) {
	underscore_bit_file_bit { $name:
		path            => $path,
		parent          => $parent,
		ordinal         => $ordinal,
		content         => $content,
		closing_content => $closing_content,
		before          => $before,
		require         => $require,
		notify          => $notify,
		subscribe       => $subscribe,
	}
}
