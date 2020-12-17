# A simple build system

## Setup

### unix

```
bash setup.sh
```

### windows

```
./setup.ps1
```

## Install packages

### local

#### release build

```
./cbuild package-name[features]:branch
```

#### debug build

```
./cbuild_debug package-name[features]:branch
```

### docker

```
./cbuild_docker package-name[features]:branch
```

### docker with CUDA support

```
./cbuild_cuda_docker package-name[features]:branch
```
