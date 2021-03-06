# Copyright (c) Christoph M. Wintersteiger
# Licensed under the MIT License.

all: libwlmcd-dev.a libwlmcd-ui.a libwlmcd-dev.so libwlmcd-ui.so tests

CXXFLAGS+=-g -MMD -MP -Wall -Wno-unused-variable -Wno-unused-function
CXXFLAGS+=-I . -Wno-psabi
CXXFLAGS+=$(shell pkg-config dbus-1 --cflags)

LDFLAGS=-g -lrt -lcrypto -lwiringPi -lgpiod -lpthread -lgpiod

# CXX=clang++-8
# CXXFLAGS+=-O1 -g -fsanitize=address -fno-omit-frame-pointer
# LDFLAGS+=-g -fsanitize=address

%.o: %.cpp
	${CXX} ${CXXFLAGS} $< -c -o $@

SRC = decoder.cpp basic.cpp logfile.cpp \
	spidev.cpp \
	evohome.cpp radbot.cpp \
	cc1101.cpp \
	sx1278.cpp \
	gpio_device.cpp \
	gpio_button.cpp \
	si4463.cpp si4463_rt.cpp \
	rfm69.cpp \
	ble100.cpp \
	relay_device.cpp \
	ina219.cpp \
	ds18b20.cpp \
	rfm69.cpp

UI_SRC = field.cpp ui.cpp basic_ui.cpp controller.cpp \
	cc1101_ui.cpp cc1101_ui_raw.cpp \
	radbot_ui.cpp evohome_ui.cpp \
	sx1278_ui_raw.cpp sx1278_ui.cpp \
	gpio_ui.cpp \
	gpio_button_field.cpp \
	si4463_ui_raw.cpp \
	rfm69_ui_raw.cpp \
	relay_ui.cpp \
	ina219_ui.cpp ina219_ui_raw.cpp \
	rfm69_ui.cpp

OBJ = $(subst .cpp,.o,$(SRC))
UI_OBJ = $(subst .cpp,.o,$(UI_SRC))

libwlmcd-dev.a: $(OBJ)
	${AR} rcs $@ $^

libwlmcd-ui.a: $(UI_OBJ)
	${AR} rcs $@ $^

libwlmcd-dev.so: $(OBJ)
	${CXX} -shared -o $@ $^ ${LDFLAGS}

libwlmcd-ui.so: $(UI_OBJ) libwlmcd-dev.so
	${CXX} -shared -o $@ $^ ${LDFLAGS} -lncurses -L . -lwlmcd-dev

tests: tests.o evohome_tests.o radbot_tests.o $(OBJ)
	${CXX} ${CXXFLAGS} -o $@ $^ ${LDFLAGS}

clean:
	rm -rf *.d *.o libwlmcd-dev.a libwlmcd-ui.a libwlmcd-dev.so libwlmcd-ui.so tests

-include *.d
