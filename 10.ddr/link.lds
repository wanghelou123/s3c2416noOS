SECTIONS
{
	. = 0x00001000;
	.text : {
		start.o
		* (.text)
	}
	.data : {
		* (.data)
	}
	bss_start = .;
	.bss : {
		* (.bss)
	}
	bss_end = .;
}
