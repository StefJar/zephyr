/* SPDX-License-Identifier: Apache-2.0 */
/* Plase keep in sync with cmake/linker_script/common/kobject-text.cmake */

#ifdef CONFIG_USERSPACE
	/* We need to reserve room for the gperf generated hash functions.
	 * Fortunately, unlike the data tables, the size of the code is
	 * reasonably predictable.
	 *
	 * The linker will error out complaining that the location pointer
	 * is moving backwards if the reserved room isn't large enough.
	 */
	PLACE_SYMBOL_HERE(_kobject_text_area_start);
	*(".kobject_data.literal*")
	*(".kobject_data.text*")
	PLACE_SYMBOL_HERE(_kobject_text_area_end);
	_kobject_text_area_used = _kobject_text_area_end - _kobject_text_area_start;

	/* In a valid build the MAX function will always evaluate to the
	second argument below, but to give the user a good error message
	when the area overflows we need to temporarily corrupt the
	location counter, and then detect the overflow with an assertion
	later on. */

	. = MAX(., _kobject_text_area_start + CONFIG_KOBJECT_TEXT_AREA);

	ASSERT(
		CONFIG_KOBJECT_TEXT_AREA >= _kobject_text_area_used,
"Reserved space for kobject text area is too small. \
Please change CONFIG_KOBJECT_TEXT_AREA to a larger number."
		);
#endif /* CONFIG_USERSPACE */
