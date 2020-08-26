# DCT2
It's an image compression algorithm using 2D Discrete Cosine Transform using Matlab as following.


a) Read the image file ‘image1.bmp’(1920*1080). Extract and display each of its three color components.
Repeat the following steps for m=1,2,3,4.

b) To compress the image, process each color component in blocks of 8×8 pixels. Obtain 2D
DCT of each block. It will have the same dimensions as the input block. Retain only the top
left square of the 2D DCT coefficients of size m×m. That is, if the DCT coefficients are
X[1:8,1:8], retain only the top left m×m coefficients, X[1: m, 1: m], assuming that the top
left coefficient is X[1,1]. The rest of coefficients are ignored.

c) Compare the size of the original and compressed images.

d) Decompress the image by applying inverse 2D DCT to each block. Display the image.

e) The quality of the decompressed image is measured using the Peak Signal-to-Noise Ratio
(PSNR=10*log(10)*(peak^2/MSE).
where peak is the peak value for the pixels according to the image datatype (e.g. for uint8
image it is 255). Mean square error (MSE) between the original image and the decompressed
image is obtained by subtracting the corresponding pixel values of two images and obtaining
the average of the square of all the differences. Obtain the PSNR for each value of m.
