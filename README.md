# harscan
## Purpose
Chrome and Firefox can record sessions and export then in a "har" format, which contains a large JSON object.  "harscan.pl" turns this JSON into something readable - 1 line per request found
## Usage
harscan(1).pl filename
## Sample output
~~~
10:06:02.469-10:06:02.535      66 ms    POST https://d2hhttptest/rest/bpm/wle/v1/service/1.a0fb4325-e3f9-4f13-9134-ba8b8774f358
10:06:02.479-10:06:02.538      59 ms    POST https://d2hhttptest/rest/bpm/wle/v1/service/1.a0fb4325-e3f9-4f13-9134-ba8b8774f358
10:06:02.492-10:06:02.547      55 ms    POST https://d2hhttptest/rest/bpm/wle/v1/service/1.ec3df3b8-6557-46cd-9f53-430996ed2563
10:06:02.501-10:06:02.572      71 ms    POST https://d2hhttptest/rest/bpm/wle/v1/service/1.018b2671-fe10-4f83-a1e1-b1368e836600
10:06:02.511-10:06:02.573      62 ms    POST https://d2hhttptest/rest/bpm/wle/v1/service/1.15cd7529-09ff-49e6-a954-9603725127cd
10:06:02.522-10:06:02.597      75 ms    POST https://d2hhttptest/rest/bpm/wle/v1/service/1.bcfc9605-e7c4-408e-84c2-14ffaafa40d8
...
~~~

## Notes
"harscan.pl" and "harscan1.pl" should return the same, they just differ in some implementation details.
