import DatePickerModule from "./DatePickerModule";

type DatePickerOptions = {
  minimumDate?: Date;
  maximumDate?: Date;
  value?: Date;
  mode?: "date" | "datetime" | "time";
};

export async function open(options?: DatePickerOptions): Promise<Date> {
  let nativePickerOptions: any = {};
  if (options) {
    if (options.value) {
      nativePickerOptions.value = options.value.getTime() / 1000;
    }

    if (options.minimumDate) {
      nativePickerOptions.minimumDate = options.minimumDate.getTime() / 1000;
    }

    if (options.maximumDate) {
      nativePickerOptions.maximumDate = options.maximumDate.getTime() / 1000;
    }
    if (options.mode) {
      nativePickerOptions.mode = options.mode;
    }
  }

  const timestamp = await DatePickerModule.open(nativePickerOptions);
  return new Date(timestamp);
}

export async function dismiss(): Promise<Date> {
  return await DatePickerModule.dismiss();
}
