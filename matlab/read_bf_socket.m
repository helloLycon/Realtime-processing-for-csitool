%READ_BF_SOCKET Reads in a file of beamforming feedback logs.
%   This version uses the *C* version of read_bfee, compiled with
%   MATLAB's MEX utility.
%
% (c) 2008-2011 Daniel Halperin <dhalperi@cs.washington.edu>
%
%   Modified by Renjie Zhang, Bingxian Lu.
%   Email: bingxian.lu@gmail.com

function read_bf_socket()

while 1
%% Build a TCP Server and wait for connection
    port = 8090;
    t = tcpip('0.0.0.0', port, 'NetworkRole', 'server');
    t.InputBufferSize = 1024*4;
    t.Timeout = inf;
    fprintf('Waiting for connection on port %d\n',port);
    fopen(t);
    fprintf('Accept connection from %s\n',t.RemoteHost);

%% Set plot parameters
    clf;
    axis([1,30,-10,30]);
    t1=0;
    m1=zeros(30,1);

%%  Starting in R2014b, the EraseMode property has been removed from all graphics objects. 
%%  https://mathworks.com/help/matlab/graphics_transition/how-do-i-replace-the-erasemode-property.html
    [VER DATESTR] = version();
    if datenum(DATESTR) > datenum('February 11, 2014')
        p = plot(t1,m1,'MarkerSize',5);
    else
        p = plot(t1,m1,'EraseMode','Xor','MarkerSize',5);
    end

    xlabel('Subcarrier index');
    ylabel('SNR (dB)');

%% Initialize variables
    cnter = 1;

%% Process all entries in socket
    % Need 3 bytes -- 2 byte size field and 1 byte code
    while 1
        %https://github.com/helloLycon/Realtime-processing-for-csitool
        msg = handle_csi_data(t);
        msg_save{cnter, 1} = msg;
        cnter = cnter + 1;

        % no csi message.
        if(0 == msg.csi_len)
            continue;
        end

        %This plot will show graphics about recent 1 csi packets
        for nRx = 1:msg.nr
            for nTx = 1:msg.nc
                set(p((nRx-1)*msg.nc+nTx),'XData', [1:msg.num_tones], 'YData', db(abs(msg.csi(nRx,nTx,:))), 'color', 'b', 'linestyle', '-');
            end
        end
        axis([1,msg.num_tones , -10 ,80]);
        drawnow;
 
    end
%% Close file
    fclose(t);
    delete(t);
end

end