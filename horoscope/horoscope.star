load("cache.star", "cache")
load("http.star", "http")
load("render.star", "render")
load("time.star", "time")

BASE_URL = "https://ohmanda.com/api/horoscope/"
STAR_SIGNS = [
    "Aquarius",
    "Pisces",
    "Aries",
    "Taurus",
    "Gemini",
    "Cancer",
    "Leo",
    "Virgo",
    "Libra",
    "Scorpio",
    "Sagittarius",
    "Capricorn"
]

def main():
    cached_horoscope = cache.get("horoscope")
    cached_sign = cache.get("sign")

    if cached_horoscope != None and cached_sign != None:
        print("CACHE")
        sign = cached_sign
        horoscope = cached_horoscope
    else:
        print("GET HOROSCOPE")

        random_index = random(len(STAR_SIGNS))
        sign = STAR_SIGNS[random_index]
        sign_url = BASE_URL + sign.lower()

        response = http.get(sign_url)
        if response.status_code != 200:
            fail("Horoscope request failed with status %d", response.status_code)

        horoscope = response.json()["horoscope"]
        cache.set("horoscope", horoscope, ttl_seconds=300)
        cache.set("sign", sign, ttl_seconds=300)
    
    print("%s: %s" % (sign, horoscope))

    return render.Root(
        delay = 80,
        child = render.Column(
            children = [
                render.Text(sign, color="#099"),
                render.Marquee(
                    child=render.WrappedText(horoscope),
                    height=32,
                    offset_start=5,
                    scroll_direction="vertical",
                    width=64
                )
            ]
        )
    )


def random(num):
    sec = time.now().nanosecond / 1000
    random_num = int(sec % num)
    return random_num
