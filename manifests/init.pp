define bitfile(
		$mode  = undef,
		$owner = undef,
		$group = undef
) {
	underscore_bit_file { $name:
		mode => $mode,
		owner => $owner,
		group => $group,
	}
}
