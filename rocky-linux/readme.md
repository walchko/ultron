![](rocky.png)

# Rocky Linux

- Rocky Linux ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/walchko/rocky/latest)

Since Redhat is being a bunch of ass hats and not letting your use
Redhat w/o a license (also shutdown Centos), Rocky Linux is supposed
to be a good surrogate since it is based on Centos.

## Using

- Build: `docker-compose build`
- Run: `docker-compose up`
    - You can add the `-d` switch to detach it from the terminal and run it in the background
- Stop:
    - if attached to terminal, use `ctrl-C`
    - if detached: `docker-compose down`

## SSH into Container

- Assuming dalek is hosting, reach from any where: `ssh -p 2222 alice@dalek.local`
- Run on the hosting system: `ssh -p 2222 alice@0.0.0.0`

## Timezone Info

There are a series of locals with timezone info in `/usr/share/zoneinfo`

```
ls /usr/share/zoneinfo/America/
Adak		Coral_Harbour  Hermosillo     Monterrey       Santarem
Anchorage	Cordoba        Indiana	      Montevideo      Santiago
Anguilla	Costa_Rica     Indianapolis   Montreal	      Santo_Domingo
Antigua		Creston        Inuvik	      Montserrat      Sao_Paulo
Araguaina	Cuiaba	       Iqaluit	      Nassau	      Scoresbysund
Argentina	Curacao        Jamaica	      New_York	      Shiprock
Aruba		Danmarkshavn   Jujuy	      Nipigon	      Sitka
Asuncion	Dawson	       Juneau	      Nome	      St_Barthelemy
Atikokan	Dawson_Creek   Kentucky       Noronha	      St_Johns
Atka		Denver	       Knox_IN	      North_Dakota    St_Kitts
Bahia		Detroit        Kralendijk     Nuuk	      St_Lucia
Bahia_Banderas	Dominica       La_Paz	      Ojinaga	      St_Thomas
Barbados	Edmonton       Lima	      Panama	      St_Vincent
Belem		Eirunepe       Los_Angeles    Pangnirtung     Swift_Current
Belize		El_Salvador    Louisville     Paramaribo      Tegucigalpa
Blanc-Sablon	Ensenada       Lower_Princes  Phoenix	      Thule
Boa_Vista	Fort_Nelson    Maceio	      Port-au-Prince  Thunder_Bay
Bogota		Fort_Wayne     Managua	      Port_of_Spain   Tijuana
Boise		Fortaleza      Manaus	      Porto_Acre      Toronto
Buenos_Aires	Glace_Bay      Marigot	      Porto_Velho     Tortola
Cambridge_Bay	Godthab        Martinique     Puerto_Rico     Vancouver
Campo_Grande	Goose_Bay      Matamoros      Punta_Arenas    Virgin
Cancun		Grand_Turk     Mazatlan       Rainy_River     Whitehorse
Caracas		Grenada        Mendoza	      Rankin_Inlet    Winnipeg
Catamarca	Guadeloupe     Menominee      Recife	      Yakutat
Cayenne		Guatemala      Merida	      Regina	      Yellowknife
Cayman		Guayaquil      Metlakatla     Resolute
Chicago		Guyana	       Mexico_City    Rio_Branco
Chihuahua	Halifax        Miquelon       Rosario
Ciudad_Juarez	Havana	       Moncton	      Santa_Isabel
```