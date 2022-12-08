import DatePickerModule from "./DatePickerModule";

type DatePickerOptions = {
  minimumDate?: number;
  maximumDate?: number;
  type?: "date" | "datetime" | "time";
};

export async function open(options?: DatePickerOptions): Promise<Date> {
  let nativePickerOptions: DatePickerOptions = {};
  if (options) {
    if (options.minimumDate) {
      nativePickerOptions.minimumDate = options.minimumDate / 1000;
    }
    if (options.maximumDate) {
      nativePickerOptions.maximumDate = options.maximumDate / 1000;
    }
    if (options.type) {
      nativePickerOptions.type = options.type;
    }
  }

  const timestamp = await DatePickerModule.open(nativePickerOptions);
  return new Date(timestamp);
}
