// Copyright (c) Christoph M. Wintersteiger
// Licensed under the MIT License.

#ifndef _UI_H_
#define _UI_H_

#include <cstdint>
#include <mutex>
#include <vector>
#include <set>

#include "field.h"

class DeviceBase;

class UI {
protected:
  static std::mutex mtx;
  static unsigned screen_height, screen_width;
  static uint64_t reset_cnt;
  unsigned logp_b, logp_x, logp_y, logp_h, logp_w, logp_scrollback;
  std::vector<FieldBase*> fields;
  size_t active_field_index;
  std::set<DeviceBase*> devices;

public:
  UI();
  virtual ~UI();

  static WINDOW *mainw, *logp, *logboxw, *cmdw, *statusp;
  static uint64_t indicator_value, max_indicator_value;

  static void Start();
  static int Log(const char *format, ...);
  static int Log(const std::string &s) { return Log("%s", s.c_str()); }
  static void Error(const char *format, ...);
  static void Info(const char *format, ...);
  static int GetKey();
  static void ResetCmd();
  static int End();

  virtual void Describe();

  static unsigned ScreenWidth() { return screen_width; }

  void ScrollUp();
  void ScrollDown();

  void First();
  void Previous();
  void Next();
  void Last();

  void Reset();
  virtual void Update(bool full);
  void Add(FieldBase *field);

  void Edit();
  static std::string GetCommand();
  void Bump();

  virtual void Layout();
  virtual std::string Name() const { return "Unnamed"; }

  const std::set<DeviceBase*>& Devices() { return devices; }
};

#endif
