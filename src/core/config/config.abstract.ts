export abstract class AbstractConfig {
    protected getNumber(key: string, defaultValue?: number): number {
        const value = process.env[key];
        if (value === undefined) {
            if (defaultValue !== undefined) {
                return defaultValue;
            }
            throw new TypeError(`Config key "${key}" MUST contain valid number. Got undefined`);
        }
        const num = Number(value);
        if (Number.isFinite(num)) {
            return num;
        }
        throw new TypeError(`Config key "${key}" MUST contain valid number. Got "${value}"`);
    }

    protected getString(key: string, defaultValue?: string): string {
        const value = process.env[key];
        if (value === undefined) {
            if (defaultValue !== undefined) {
                return defaultValue;
            }
            throw new TypeError(`Config key "${key}" MUST contain string. Got undefined`);
        }
        return value;
    }

    protected getBoolean(key: string, defaultValue?: boolean): boolean {
        const value = process.env[key];
        if (value === undefined) {
            if (defaultValue !== undefined) {
                return defaultValue;
            }
            throw new TypeError(`Config key "${key}" MUST contain valid boolean. Got undefined`);
        }
        if (value === 'true') return true;
        if (value === 'false') return false;
        throw new TypeError(`Config key "${key}" MUST contain valid boolean. Got "${value}"`);
    }
}
