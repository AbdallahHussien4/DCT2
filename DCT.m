%Read Image
rgbImage= imread('image1.bmp');
[Rows Columns]=size(rgbImage);
Columns=Columns/3;

%Split the image to its RGB
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);

%Encoding
%Repeate Each Step For M=1,2,3,4
for m=1:4
EncR = int16(zeros(8,8));
TempDataR = zeros(8,8);
EncG = int16([]);
TempDataG = zeros(8,8);
EncB = int16([]);
TempDataB = zeros(8,8);

%Get the DCT for Each Channel
for i=[1:8:Rows]
    for j=[1:8:Columns]
        BlockR=redChannel(i:i+7,j:j+7);
        TempDataR=dct2(BlockR);
        RedDCT(i:i+7,j:j+7)=TempDataR;
        BlockG=greenChannel(i:i+7,j:j+7);
        TempDataG=dct2(BlockG);
        GreenDCT(i:i+7,j:j+7)=TempDataG;
        BlockB=blueChannel(i:i+7,j:j+7);
        TempDataB=dct2(BlockB);
        BlueDCT(i:i+7,j:j+7)=TempDataB;
    end
end
c=1;
r=1;
%Get The Top Left M*M Square and store it in new matrix.
for i=[1:8:Rows]
    for j=[1:8:Columns]
        BlockR = RedDCT(i:i+7,j:j+7);
        EncR(r:r+m-1,c:c+m-1)=BlockR(1:m,1:m);
        BlockG = GreenDCT(i:i+7,j:j+7);
        EncG(r:r+m-1,c:c+m-1)=BlockG(1:m,1:m);
        BlockB = BlueDCT(i:i+7,j:j+7);
        EncB(r:r+m-1,c:c+m-1)=BlockB(1:m,1:m);
        c=c+m;
    end
    c=1;
    r=r+m;
end

%Save the encoded matrix.
Enc=cat(3,EncR,EncG,EncB);
FileName = sprintf ( 'EncM %i %s', m, '.bmp' );
save(FileName, 'Enc');

%Compare the Size of the original image and the copressed image.
%Image Size = Rows*Columns*3.
%Compressed Size = m^2(Size of the top left square)*
%Rows*Columns/64(Number of blocks)*3
fprintf('The Size of the Original image with m=%d is %d Pixels.\n',m,Rows*Columns*3);
fprintf('The Size of the Compressed image with m=%d is %d Pixels.\n',m,m^2*(Rows*Columns/64)*3);


%Decoidng

DecR=uint8([]);
DecG=uint8([]);
DecB=uint8([]);
c=1;
r=1;
BlockR=zeros(8,8);
BlockG=zeros(8,8);
BlockB=zeros(8,8);

%Construct matrix with original size from the encoded matrix.
for i=[1:8:Rows]
    for j=[1:8:Columns]
        BlockR(1:m,1:m) = EncR(r:r+m-1,c:c+m-1);
        TopLeftSquaresR(i:i+7,j:j+7) = BlockR;
        BlockG(1:m,1:m) = EncG(r:r+m-1,c:c+m-1);
        TopLeftSquaresG(i:i+7,j:j+7) = BlockG;
        BlockB(1:m,1:m) = EncB(r:r+m-1,c:c+m-1);
        TopLeftSquaresB(i:i+7,j:j+7) = BlockB;
        c=c+m;
    end
    c=1;
    r=r+m;
end

%Apply Inverse Dct2
for i=[1:8:Rows]
    for j=[1:8:Columns]
        BlockR = TopLeftSquaresR(i:i+7,j:j+7);
        BlockR=idct2(BlockR);
        DecR(i:i+7,j:j+7)=BlockR;
        BlockG = TopLeftSquaresG(i:i+7,j:j+7);
        BlockG=idct2(BlockG);
        DecG(i:i+7,j:j+7)=BlockG;
        BlockB = TopLeftSquaresB(i:i+7,j:j+7);
        BlockB=idct2(BlockB);
        DecB(i:i+7,j:j+7)=BlockB;
    end
end

%Combine the three channels together
Dec=cat(3,DecR,DecG,DecB);

%Save and Display the image
FileName = sprintf ( 'OutM %i %s', m, '.bmp' );
imwrite(Dec,FileName);
figure
imshow(Dec);

%Caculate the quality (PSNR).
Peak=255;   %Data type is uint8.
fprintf('The PSNR with m=%d is %d.\n',m,psnr(Dec,rgbImage,Peak));

%Compute PSNR Manually.

% MSERed=sum(sum(((int16(redChannel)-int16(DecR)).^2)))/(Columns*Rows);
% MSEGreen=sum(sum(((int16(greenChannel)-int16(DecG)).^2)))/(Columns*Rows);
% MSEBlue=sum(sum(((int16(blueChannel)-int16(DecB)).^2)))/(Columns*Rows);
% MSE=(MSERed+MSEBlue+MSEGreen)/3;
% PSNR=10*log10((Peak^2)/MSE);
% fprintf('The PSNR with m=%d is %d.\n',m,PSNR);


end