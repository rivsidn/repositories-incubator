# add-symbol-file /usr/lib/debug/.build-id/23/f365cf00be49a4a99229d2b8cb0e0555abbddb.debug
# add-symbol-file /usr/lib/debug/.build-id/46/a7e7bf9aacf084f0184190f1dadaea43e0198a.debug
# add-symbol-file /usr/lib/debug/.build-id/89/7a56fdba3656decd5eaea38431bcbf3784e946.debug
# add-symbol-file /usr/lib/debug/.build-id/c8/cd5c1206ee99e39e54b03f1fa0ec549e2c194f.debug
# add-symbol-file /usr/lib/debug/.build-id/d1/f3fa989208156a5d35e54d03c515c8ab9bab3f.debug
# add-symbol-file /usr/lib/debug/.build-id/e9/d4de443fe07d291ae665f3641607e6a6b839ed.debug
# add-symbol-file /usr/lib/debug/.build-id/fd/6f8753c162be3d530f48d0ab827d7dea0d3268.debug
# add-symbol-file /usr/lib/debug/.build-id/ff/67265024957503040891552733483f8a18137a.debug
# set substitute-path /usr/src/glib2.0-2.82.1-0ubuntu1/debian/build/deb /home/yuchao/source_code/glib/glib-2.82.1/_build/deb/gdb_source_mark

add-symbol-file /usr/lib/debug/.build-id/3b/da4d7bb00b8f54843143d0646a9efec7e6f147.debug
add-symbol-file /usr/lib/debug/.build-id/65/b0a48791b8a1f047c2a6768714a431e1cde4f8.debug
add-symbol-file /usr/lib/debug/.build-id/9a/e42e9fbc1f599813442783945bf9ed12b336a3.debug
add-symbol-file /usr/lib/debug/.build-id/c5/b3325844fb35db0aad817c1086261d1d1f608c.debug
add-symbol-file /usr/lib/debug/.build-id/e2/74d3b4afd6f5a4adec09fad07782265a269495.debug
add-symbol-file /usr/lib/debug/.build-id/e4/b295ec2fc849132dafd136750dacd65ce4b85b.debug
add-symbol-file /usr/lib/debug/.build-id/e8/45b8fd2f396872c036976626389ffc4f50c9c5.debug
set substitute-path ./debian/build/deb /home/yuchao/source_code/glib-2.72.4-annotation/_build/deb/gdb_source_mark


set args -m 1024 -smp 2 -hda /home/yuchao/Downloads/test.img --enable-kvm -vnc :1

run

# layout src

define trace_g_source_add_poll
	b g_source_add_poll
	commands
		print fd->fd
	end
end

define show_gpollfds
	set $i = 0
	printf "man loop listen %d fds\n", glib_n_poll_fds
	while ( $i < glib_n_poll_fds )
		print ((GPollFD *)(gpollfds->data))[$i]->fd
		set $i = $i + 1
	end
end

define iterate_context_fds
	echo TODO
	echo
end
