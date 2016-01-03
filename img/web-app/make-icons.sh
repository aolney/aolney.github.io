cp --remove-destination photo.jpg icon-192p.png 
mogrify -resize 192x192 -format png -filter Lanczos icon-192p.png
cp --remove-destination photo.jpg icon-144p.png 
mogrify -resize 144x -format png -filter Lanczos icon-144p.png
cp --remove-destination photo.jpg icon-96p.png 
mogrify -resize 96x -format png -filter Lanczos icon-96p.png
cp --remove-destination photo.jpg icon-72p.png 
mogrify -resize 72x -format png -filter Lanczos icon-72p.png
cp --remove-destination photo.jpg icon-48p.png 
mogrify -resize 48x -format png -filter Lanczos icon-48p.png
cp --remove-destination photo.jpg icon-36p.png 
mogrify -resize 36x -format png -filter Lanczos icon-36p.png

