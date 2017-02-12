## Welcome to HArshaD

This is a suite of simple tools to help the user to Handle Darshan Data without being familiar exactly with specific commands.

### Instructions

* Connect to the system with ```ssh -Y```

#### Tool Open Darshan

* Edit the script open_darshan.sh and declare for the variable darshan_path the path where the logs are saved

* To load Darshan data for your last experiment on the **same** day, execute 

```
./open_darshan.sh
```
* To load darshan data from specific job, execute 

```
./open_darshan.sh job_id
```

The PDF file will be created in the folder 

```
experiments/year/month/executable/ (v0.2)
```
or

```
experiments/executable/year/month/ (development)
```

#### Tool Compare Darshan

* Available with release v0.3 and afterwards

* Dependency on PDFjam software

  * [Download PDFjam](http://freecode.com/urls/f25b51928fce8fe1fb55c071e45580ce)

  * Use the executable in the bin folder. We do not support this software 

* Edit the script compare_darshan.sh and declare for the variable darshan_path the path where the logs are saved

* To compare the Darshan data of two jobs with job_id1 and job_id2, execute 

```
./compare_darshan.sh job_id1 job_id2
```

Example of one single PDF:

![comparison](https://github.com/gmarkomanolis/HArshaD/blob/master/files_for_readme/comparison_darshan_example.png?raw=true)

### Releases

{% for relea in site.github.releases %}

**Version**: {{ relea.tag_name }} 

Date: {{ relea.published_at }}

Changelog: 

{{ relea.body }}

[Download]({{ relea.tarball_url }}) 

{% endfor %}


### Testbed platform

The scripts were tested with CRAY-XC40 ShaheenII and Darshan v2.3.1

### ToDo

- [X] Automatic organization into folders (v0.2 and afterwards)
- [ ] Adapt with newer Darshan version

