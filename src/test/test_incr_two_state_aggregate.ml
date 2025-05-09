let () =
  let fname = "incr_input4.txt" in
  Reactive.init "test_incr_aggregate.rheap" (1024 * 1024);

  let inputs = Reactive.input_files [| fname |] in

  let words =
    Reactive.map inputs (fun key trackers ->
      let content = Reactive.read_file key (Array.get trackers 0) in
      let ws = String.split_on_char ' ' content in
      Array.of_list (List.map (fun w -> (w, [| w |])) ws)
    )
  in

  let lengths =
    Reactive.map words (fun key arr ->
      [| (key, [| String.length key |]) |]
    )
  in

  Reactive.exit ();
  let count = Array.length (Reactive.get_array lengths "hello") in
  Printf.printf "Length for key 'hello': %d\n" count
