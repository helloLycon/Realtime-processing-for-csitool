%%
%% =====================================================================================
%%       Filename:  read_log_file.m 
%%
%%    Description:  extract the CSI, payload, and packet status information from the log
%%                  file
%%        Version:  1.0
%%
%%         Author:  Yaxiong Xie 
%%         Email :  <xieyaxiongfly@gmail.com>
%%   Organization:  WANDS group @ Nanyang Technological University 
%%
%%   Copyright (c)  WANDS group @ Nanyang Technological University
%% =====================================================================================
%%

function ret = handle_csi_data(f)

while (1)
    field_len = fread(f, 1, 'uint16');
    fprintf('Block length is:%d\n',field_len);
    
    timestamp = fread(f, 1, 'float64');
	csi_matrix.timestamp = timestamp;
	fprintf('timestamp is %d\n',timestamp);

    csi_len = fread(f, 1, 'uint16');
	csi_matrix.csi_len = csi_len;
    fprintf('csi_len is %d\n',csi_len);

    tx_channel = fread(f, 1, 'uint16');
	csi_matrix.channel = tx_channel;
    fprintf('channel is %d\n',tx_channel);
   
    err_info = fread(f, 1,'uint8');
    csi_matrix.err_info = err_info;
    fprintf('err_info is %d\n',err_info);
    
    noise_floor = fread(f, 1, 'uint8');
	csi_matrix.noise_floor = noise_floor;
    fprintf('noise_floor is %d\n',noise_floor);
    
    Rate = fread(f, 1, 'uint8');
	csi_matrix.Rate = Rate;
	fprintf('rate is %x\n',Rate);
    
    
    bandWidth = fread(f, 1, 'uint8');
	csi_matrix.bandWidth = bandWidth;
	fprintf('bandWidth is %d\n',bandWidth);
    
    num_tones = fread(f, 1, 'uint8');
    num_tones = uint32(num_tones);
	csi_matrix.num_tones = num_tones;
	fprintf('num_tones is %d  ',num_tones);

	nr = fread(f, 1, 'uint8');
    nr = uint32(nr);
	csi_matrix.nr = nr;
	fprintf('nr is %d  ',nr);

	nc = fread(f, 1, 'uint8');
    nc = uint32(nc);
	csi_matrix.nc = nc;
	fprintf('nc is %d\n',nc);
	
	rssi = fread(f, 1, 'uint8');
	csi_matrix.rssi = rssi;
	fprintf('rssi is %d\n',rssi);

	rssi1 = fread(f, 1, 'uint8');
	csi_matrix.rssi1 = rssi1;
	fprintf('rssi1 is %d\n',rssi1);

	rssi2 = fread(f, 1, 'uint8');
	csi_matrix.rssi2 = rssi2;
	fprintf('rssi2 is %d\n',rssi2);

	rssi3 = fread(f, 1, 'uint8');
	csi_matrix.rssi3 = rssi3;
	fprintf('rssi3 is %d\n',rssi3);

    payload_len = fread(f, 1, 'uint16');
	csi_matrix.payload_len = payload_len;
    fprintf('payload length: %d\n',payload_len);	
    
    if csi_len > 0
        csi_buf = fread(f, csi_len, 'uint8');
        csi_buf = uint8(csi_buf);
	    csi = read_csi(csi_buf, nr, nc, num_tones);
	    csi_matrix.csi = csi;
    else
        csi_matrix.csi = 0;
    end       
    
    if payload_len > 0
        data_buf = fread(f, payload_len, 'uint8');
        data_buf = uint8(data_buf);
	    csi_matrix.payload = data_buf;
    else
        csi_matrix.payload = 0;
    end

    ret = csi_matrix;
    break;
end
end
