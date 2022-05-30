from PIL import Image

tile_size = 200

n = int(input())
a = [list(map(int, input().split())) for i in range(n)]

result = Image.new("RGB", (n * tile_size, n * tile_size), (255, 255, 255))

for i in range(n):
    for j in range(n):
        tile_file = f'img/{a[i][j]}.png'
        tile_img = Image.open(tile_file)
        result.paste(tile_img, (j * tile_size, i * tile_size))

result.save('./result.png')
