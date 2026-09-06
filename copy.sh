D="ds-pico-setup:/app";

mkdir -p setup;

docker cp $D/pico-launcher/_pico ./setup/;
docker cp $D/pico-launcher/LAUNCHER.nds ./setup/_picoboot.nds;
docker cp $D/pico-loader/picoLoader7.bin ./setup/_pico/;
docker cp $D/pico-loader/picoLoader9_DSPICO.bin ./setup/_pico/picoLoader9.bin;
docker cp $D/pico-loader/data/aplist.bin ./setup/_pico/aplist.bin;
docker cp $D/pico-loader/data/savelist.bin ./setup/_pico/savelist.bin;
