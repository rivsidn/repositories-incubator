
add-symbol-file /usr/lib/debug/.build-id/23/f365cf00be49a4a99229d2b8cb0e0555abbddb.debug
add-symbol-file /usr/lib/debug/.build-id/46/a7e7bf9aacf084f0184190f1dadaea43e0198a.debug
add-symbol-file /usr/lib/debug/.build-id/89/7a56fdba3656decd5eaea38431bcbf3784e946.debug
add-symbol-file /usr/lib/debug/.build-id/c8/cd5c1206ee99e39e54b03f1fa0ec549e2c194f.debug
add-symbol-file /usr/lib/debug/.build-id/d1/f3fa989208156a5d35e54d03c515c8ab9bab3f.debug
add-symbol-file /usr/lib/debug/.build-id/e9/d4de443fe07d291ae665f3641607e6a6b839ed.debug
add-symbol-file /usr/lib/debug/.build-id/fd/6f8753c162be3d530f48d0ab827d7dea0d3268.debug
add-symbol-file /usr/lib/debug/.build-id/ff/67265024957503040891552733483f8a18137a.debug

set substitute-path /usr/src/glib2.0-2.82.1-0ubuntu1/debian/build/deb /home/yuchao/source_code/glib/glib-2.82.1/_build/deb/gdb_source_mark

set args -m 1024 -smp 2 -hda /home/yuchao/Downloads/test.img --enable-kvm -vnc :1

b glib_pollfds_fill
# b qemu_signalfd
# b sigfd_handler

run

finish

# layout src

define show_gpollfds
	set $i = 0
	printf "man loop listen %d fds\n", glib_n_poll_fds
	while ( $i < glib_n_poll_fds )
		print ((GPollFD *)(gpollfds->data))[$i]->fd
		set $i = $i + 1
	end
end

define iterate_context_fds
	# TODO
	echo TODO
	echo
end
