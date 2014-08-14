define bitfile::bit(
		$path,
		$content,
		$ordinal = 50
) {
	underscore_bit_file_bit { $name:
		path      => $path,
		ordinal   => $ordinal,
		content   => $content,
		before    => $before,
		require   => $require,
		notify    => $notify,
		subscribe => $subscribe,
	}
}
