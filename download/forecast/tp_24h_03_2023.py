import cdsapi

dataset = "seasonal-original-single-levels"
request = {
    "originating_centre": "ecmwf",
    "system": "51",
    "variable": ["total_precipitation"],
    "year": ["2023"],
    "month": ["03"],
    "day": ["01"],
    "leadtime_hour": [
        "24",
        "48",
        "72",
        "96",
        "120",
        "144",
        "168",
        "192",
        "216",
        "240",
        "264",
        "288",
        "312",
        "336",
        "360",
        "384",
        "408",
        "432",
        "456",
        "480",
        "504",
        "528",
        "552",
        "576",
        "600",
        "624",
        "648",
        "672",
        "696",
        "720",
        "744",
        "768",
        "792",
        "816",
        "840",
        "864",
        "888",
        "912",
        "936",
        "960",
        "984",
        "1008",
        "1032",
        "1056",
        "1080",
        "1104",
        "1128",
        "1152",
        "1176",
        "1200",
        "1224",
        "1248",
        "1272",
        "1296",
        "1320",
        "1344",
        "1368",
        "1392",
        "1416",
        "1440",
        "1464",
        "1488",
        "1512",
        "1536",
        "1560",
        "1584",
        "1608",
        "1632",
        "1656",
        "1680",
        "1704",
        "1728",
        "1752",
        "1776",
        "1800",
        "1824",
        "1848",
        "1872",
        "1896",
        "1920",
        "1944",
        "1968",
        "1992",
        "2016",
        "2040",
        "2064",
        "2088",
        "2112",
        "2136",
        "2160",
        "2184",
        "2208",
        "2232",
        "2256",
        "2280",
        "2304",
        "2328",
        "2352",
        "2376",
        "2400",
        "2424",
        "2448",
        "2472",
        "2496",
        "2520",
        "2544",
        "2568",
        "2592",
        "2616",
        "2640",
        "2664",
        "2688",
        "2712",
        "2736",
        "2760",
        "2784",
        "2808",
        "2832",
        "2856",
        "2880",
        "2904",
        "2928",
        "2952",
        "2976",
        "3000",
        "3024",
        "3048",
        "3072",
        "3096",
        "3120",
        "3144",
        "3168",
        "3192",
        "3216",
        "3240",
        "3264",
        "3288",
        "3312",
        "3336",
        "3360",
        "3384",
        "3408",
        "3432",
        "3456",
        "3480",
        "3504",
        "3528",
        "3552",
        "3576",
        "3600",
        "3624",
        "3648",
        "3672",
        "3696",
        "3720",
        "3744",
        "3768",
        "3792",
        "3816",
        "3840",
        "3864",
        "3888",
        "3912",
        "3936",
        "3960",
        "3984",
        "4008",
        "4032",
        "4056",
        "4080",
        "4104",
        "4128",
        "4152",
        "4176",
        "4200",
        "4224",
        "4248",
        "4272",
        "4296",
        "4320",
        "4344",
        "4368",
        "4392",
        "4416",
        "4440",
        "4464",
        "4488",
        "4512",
        "4536",
        "4560",
        "4584",
        "4608",
        "4632",
        "4656",
        "4680",
        "4704",
        "4728",
        "4752",
        "4776",
        "4800",
        "4824",
        "4848",
        "4872",
        "4896",
        "4920",
        "4944",
        "4968",
        "4992",
        "5016",
        "5040",
        "5064",
        "5088",
        "5112",
        "5136",
        "5160"
    ],
    "data_format": "netcdf",
    "area": [43.3, 1.5, 41.3, 3.5]
}

client = cdsapi.Client()
client.retrieve(dataset, request, "tp_24h_03_2023.nc")

